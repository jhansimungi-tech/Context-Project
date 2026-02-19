"""
TC046: PUT update-account-details rejects request without valid Bearer token (CSRF/cross-origin protection)
Target: 3_JKYog_2.0_backend - /api/user/update-account-details
Prerequisites: Backend running at localhost:3001 (or set BASE_URL env)
"""
import os
import sys

try:
    import requests
except ImportError:
    print("Install requests: pip install requests")
    sys.exit(1)

BASE_URL = os.environ.get("TEST_BACKEND_URL", "http://localhost:3001")
ENDPOINT = f"{BASE_URL}/api/user/update-account-details"

VALID_BODY = {
    "firstName": "Test",
    "lastName": "User",
    "dateOfBirth": "1990-01-01",
    "gender": "male",
    "country": "US",
    "phoneNumber": "+15551234567",
}


def test_no_auth_returns_401():
    """PUT without Authorization header must return 401."""
    resp = requests.put(
        ENDPOINT,
        json=VALID_BODY,
        headers={"Content-Type": "application/json"},
        timeout=10,
    )
    assert resp.status_code == 401, f"Expected 401, got {resp.status_code}"


def test_invalid_token_returns_401():
    """PUT with invalid Bearer token must return 401."""
    resp = requests.put(
        ENDPOINT,
        json=VALID_BODY,
        headers={
            "Content-Type": "application/json",
            "Authorization": "Bearer invalid_token_12345",
        },
        timeout=10,
    )
    assert resp.status_code == 401, f"Expected 401, got {resp.status_code}"


if __name__ == "__main__":
    print(f"Testing {ENDPOINT}")
    try:
        test_no_auth_returns_401()
        print("PASS: No auth -> 401")
    except AssertionError as e:
        print(f"FAIL: {e}")
        sys.exit(1)
    try:
        test_invalid_token_returns_401()
        print("PASS: Invalid token -> 401")
    except AssertionError as e:
        print(f"FAIL: {e}")
        sys.exit(1)
    print("TC046 passed.")
