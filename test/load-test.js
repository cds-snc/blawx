import http from 'k6/http';
import { check, sleep } from 'k6';
import { parseHTML } from 'k6/html';
import { randomIntBetween } from 'https://jslib.k6.io/k6-utils/1.2.0/index.js';
import { login } from './auth.js';

// Test configuration
export const options = {
  scenarios: {
    createRuleFlow: {
      executor: 'ramping-vus',
      exec: 'createRuleDocument',
      startVUs: 1,
      stages: [
        { duration: '30s', target: 5 },
        { duration: '2m', target: 10 },
        { duration: '7m', target: 10 },
        { duration: '30s', target: 0 },
      ],
    },
  },
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<1000'],
  },
};

const BASE_URL = __ENV.BLAWX_BASE_URL || 'https://blawx.cdssandbox.xyz';
const USERNAME = __ENV.BLAWX_USERNAME || '';
const PASSWORD = __ENV.BLAWX_PASSWORD || '';

export function setup() {
  console.log(`Starting load test for ${BASE_URL}`);
  
  if (!USERNAME || !PASSWORD) {
    console.error('BLAWX_USERNAME and BLAWX_PASSWORD must be set in the environment');
    throw new Error('Missing credentials');
  }
  
  return { baseUrl: BASE_URL };
}

export default function(data) {
  const baseUrl = data.baseUrl;
  
  const loginSuccess = login(baseUrl, USERNAME, PASSWORD);
  
  if (!loginSuccess) {
    console.error('Login failed, skipping rest of scenario');
    return;
  }
  
  let response = http.get(baseUrl);
  check(response, {
    'home page status is 200': (r) => r.status === 200,
  });

  response = http.get(`${baseUrl}/`);
  check(response, {
    'projects page accessible': (r) => r.status === 200,
  });
  
  // Check Published Projects
  const doc = parseHTML(response.body);
  const publishedLink = doc.find('a:contains("Published Projects")').attr('href');
  
  if (publishedLink) {
    response = http.get(`${baseUrl}${publishedLink}`);
    check(response, {
      'published projects accessible': (r) => r.status === 200,
    });
  }
}

// Test creating a new rule document
export function createRuleDocument() {
  const baseUrl = BASE_URL;
  
  const loginSuccess = login(baseUrl, USERNAME, PASSWORD);
  
  if (!loginSuccess) {
    console.error('Login failed, skipping rest of scenario');
    return;
  }

  sleep(randomIntBetween(1, 3));
  
  // Step 1: GET request to /create
  let response = http.get(`${baseUrl}/create/`);
  check(response, {
    'create page status is 200': (r) => r.status === 200,
  });
  
  // Extract CSRF token
  const doc = parseHTML(response.body);
  const csrfInput = doc.find('input[name="csrfmiddlewaretoken"]');
  
  if (!csrfInput || csrfInput.size() === 0) {
    console.error('CSRF token input not found in create page');
    return;
  }
  
  const csrfToken = csrfInput.attr('value');
  
  if (!csrfToken) {
    console.error('CSRF token value not found');
    return;
  }
  
  // Step 2: POST request to /create with form data
  const randomNumber = randomIntBetween(1, 99999);
  const ruleDocName = `Mortality Act ${randomNumber}`;
  const ruleText = `Mortality Act

1. Humans are mortal.`;
  
  const formData = {
    csrfmiddlewaretoken: csrfToken,
    ruledoc_name: ruleDocName,
    rule_text: ruleText,
  };
  
  response = http.post(`${baseUrl}/create/`, formData, {
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Referer': `${baseUrl}/create/`,
    },
  });
  check(response, {
    'create POST successful': (r) => r.status === 200,
  });
  
  // Step 3: GET request to /tester/mortality-act-<randomNumber>/
  const testerPath = `/tester/mortality-act-${randomNumber}/`;
  response = http.get(`${baseUrl}${testerPath}`);
  check(response, {
    'tester page status is 200': (r) => r.status === 200,
  });
  const testerDoc = parseHTML(response.body);
  const h1Text = testerDoc.find('h1').text();
  check(response, {
    'h1 contains rule document name': (r) => h1Text.includes(ruleDocName),
  });
  
  // Step 4: GET request to delete page
  const deletePath = `/tester/mortality-act-${randomNumber}/delete/`;
  response = http.get(`${baseUrl}${deletePath}`);
  check(response, {
    'delete page status is 200': (r) => r.status === 200,
  });
  
  // Extract CSRF token from delete page
  const deleteDoc = parseHTML(response.body);
  const deleteCsrfToken = deleteDoc.find('input[name="csrfmiddlewaretoken"]').attr('value');
  
  if (!deleteCsrfToken) {
    console.error('CSRF token not found on delete page');
    return;
  }
  
  // Step 5: POST request to delete
  const deleteFormData = {
    csrfmiddlewaretoken: deleteCsrfToken,
  };
  
  response = http.post(`${baseUrl}${deletePath}`, deleteFormData, {
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Referer': `${baseUrl}${deletePath}`,
    },
  });
  check(response, {
    'delete POST successful': (r) => r.status === 200 || r.status === 302,
  });

  sleep(randomIntBetween(1, 3));
}

export function teardown(data) {
  console.log('Load test completed');
}
