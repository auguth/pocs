import json

def validate_test_results(json_file, test_results_file):
    with open(json_file, 'r') as file:
        expected_outcomes = json.load(file)

    errors = []

    with open(test_results_file, 'r') as file:
        for line in file:
            if line.startswith('test') and ' ... ' in line:
                parts = line.split(' ... ')
                test_name = parts[0].split()[1]
                actual_result = parts[1].strip()

                if test_name in expected_outcomes and expected_outcomes[test_name] != actual_result:
                    errors.append(f"Test result not matching for: {test_name}. Expected: {expected_outcomes[test_name]}, Found: {actual_result}")
                elif test_name not in expected_outcomes:
                   print(f"Test not found for {test_name}, with result {actual_result}")

    if errors:
        for error in errors:
            print(error)
        raise Exception("Test validation failed")

if __name__ == "__main__":
    validate_test_results('tests/test.json', 'test_results.txt')
