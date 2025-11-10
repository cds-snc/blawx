import http from 'k6/http';
import { check, sleep, randomIntBetween } from 'k6';
import { parseHTML } from 'k6/html';
import { login } from './auth.js';

// Test configuration
export const options = {
  stages: [
    { duration: '30s', target: 5 },
    { duration: '2m', target: 10 },
    { duration: '7m', target: 10 },
    { duration: '30s', target: 0 },
  ],
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
  
  sleep(randomIntBetween(1, 5));
  
  let response = http.get(baseUrl);
  check(response, {
    'home page status is 200': (r) => r.status === 200,
  });
  
  sleep(randomIntBetween(1, 5));
  
  response = http.get(`${baseUrl}/`);
  check(response, {
    'projects page accessible': (r) => r.status === 200,
  });
  
  sleep(randomIntBetween(1, 5));
  
  // Check Published Projects
  const doc = parseHTML(response.body);
  const publishedLink = doc.find('a:contains("Published Projects")').attr('href');
  
  if (publishedLink) {
    response = http.get(`${baseUrl}${publishedLink}`);
    check(response, {
      'published projects accessible': (r) => r.status === 200,
    });
  }
  
  sleep(randomIntBetween(1, 5));
}

export function teardown(data) {
  console.log('Load test completed');
}
