import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from 'k6/html';

/**
 * Authenticate with Blawx application
 * Extracts CSRF token from login page and performs login
 * 
 * @param {string} baseUrl - Base URL of the application
 * @param {string} username - Username for login
 * @param {string} password - Password for login
 * @returns {boolean} - True if login successful, false otherwise
 */
export function login(baseUrl, username, password) {
  const loginUrl = `${baseUrl}/accounts/login`;
  
  // Step 1: Get the login page to extract CSRF token
  const loginPageResponse = http.get(loginUrl);
  
  const loginPageCheck = check(loginPageResponse, {
    'login page loaded': (r) => r.status === 200,
  });
  
  if (!loginPageCheck) {
    console.error(`Failed to load login page. Status: ${loginPageResponse.status}`);
    return false;
  }
  
  // Step 2: Parse HTML to extract CSRF token
  const doc = parseHTML(loginPageResponse.body);
  const csrfToken = doc.find('input[name="csrfmiddlewaretoken"]').attr('value');
  
  if (!csrfToken) {
    console.error('CSRF token not found in login page');
    return false;
  }
  
  // Step 3: Submit login form with credentials and CSRF token
  const loginPayload = {
    csrfmiddlewaretoken: csrfToken,
    username: username,
    password: password,
  };
  
  const loginResponse = http.post(loginUrl, loginPayload, {
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Referer': loginUrl,
    },
    redirects: 0, // Don't follow redirects automatically to check for successful login
  });
  
  // Step 4: Verify login was successful
  // Successful login typically redirects (302) or returns 200
  const loginSuccess = check(loginResponse, {
    'login successful': (r) => r.status === 302 || r.status === 200,
    'no login errors': (r) => !r.body.includes('Your username and password didn\'t match. Please try again.'),
  });
  
  if (loginSuccess) {
    if (loginResponse.status === 302) {
      let redirectUrl = loginResponse.headers['Location'] || '/';
      
      // Handle relative URLs - prepend baseUrl if needed
      if (redirectUrl.startsWith('/')) {
        redirectUrl = `${baseUrl}${redirectUrl}`;
      }
      
      const finalResponse = http.get(redirectUrl);
      
      check(finalResponse, {
        'redirected to home': (r) => r.status === 200,
      });
    }
  } else {
    console.error(`Login failed. Status: ${loginResponse.status}`);
  }
  
  return loginSuccess;
}
