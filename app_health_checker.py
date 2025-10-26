import requests
import sys

def check_application_status(url: str):
    """
    Checks the health of an application by sending an HTTP GET request.

    Args:
        url (str): The URL of the application to check.
    """
    try:
        # Set a timeout to prevent the script from hanging indefinitely
        response = requests.get(url, timeout=5)

        # Check if the status code is in the success range (e.g., 200 OK)
        if 200 <= response.status_code < 300:
            print(f"✅ Application at {url} is UP.")
            print(f"Status Code: {response.status_code}")
            return True
        else:
            print(f"❌ Application at {url} is DOWN.")
            print(f"Status Code: {response.status_code}")
            return False

    except requests.exceptions.Timeout:
        print(f"❌ Application at {url} is DOWN. The request timed out.")
        return False
    except requests.exceptions.ConnectionError:
        print(f"❌ Application at {url} is DOWN. A connection error occurred.")
        return False
    except requests.exceptions.RequestException as e:
        print(f"❌ An unexpected error occurred: {e}")
        return False

if __name__ == "__main__":
    # Pass the URL as a command-line argument or define it here
    if len(sys.argv) > 1:
        target_url = sys.argv[1]
    else:
        # Default URL to check if none is provided
        target_url = "http://google.com"

    print(f"--- Checking application health for: {target_url} ---")
    check_application_status(target_url)
    print("--------------------------------------------------")

