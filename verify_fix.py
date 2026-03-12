import requests
import sys

BASE_URL = "http://localhost:3000/api"

def test_fix():
    email = "verify_proxy_fix_v2@example.com"
    password = "SafePassword123!"

    print(f"1. Attempting Registration for {email}...")
    try:
        reg_res = requests.post(f"{BASE_URL}/register", json={"email": email, "password": password})
        if reg_res.status_code == 200:
            print("   Registration Success.")
        elif reg_res.status_code == 400 and "already registered" in reg_res.text:
            print("   User already exists. Proceeding to login.")
        else:
            print(f"   Registration Failed: {reg_res.status_code} - {reg_res.text}")
            # Try login anyway, maybe it exists
    except Exception as e:
        print(f"   Registration Network Error: {e}")
        return

    print(f"2. Attempting Login via Proxy...")
    try:
        login_res = requests.post(f"{BASE_URL}/login", json={"email": email, "password": password})
        
        if login_res.status_code == 200:
            data = login_res.json()
            token = data.get("access_token")
            if token:
                print(f"   Login Success! Token received (Starts with: {token[:10]}...)")
                
                # 3. Verify Token Validity with Backend
                print("3. Verifying Token with Backend /users/me via Proxy...")
                me_res = requests.get(f"{BASE_URL}/proxy/users/me", headers={"Authorization": f"Bearer {token}"})
                
                if me_res.status_code == 200:
                    user_data = me_res.json()
                    print(f"   Verification Success! Logged in as: {user_data.get('email')}")
                    print("\n[CONCLUSION] The Auth Proxy Fix is WORKING.")
                else:
                    print(f"   Verification Failed: {me_res.status_code} - {me_res.text}")
            else:
                print(f"   Login Success but No Token? {data}")
        else:
            print(f"   Login Failed: {login_res.status_code} - {login_res.text}")

    except Exception as e:
        print(f"   Login Network Error: {e}")

if __name__ == "__main__":
    test_fix()
