import xml.etree.ElementTree as ET

def validate_test_results(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()

    expected_failures = set()
    unexpected_passes = set()
    for testsuite in root.findall('testsuite'):
        for testcase in testsuite:
            if testcase.tag == 'testcase':
                test_name = f"{testcase.attrib['classname']}.{testcase.attrib['name']}"
                if testcase.find('failure') is not None:
                    expected_failures.add(test_name)
                else:
                    unexpected_passes.add(test_name)

    with open('test_results.txt', 'r') as file:
        actual_results = file.read()

    errors = []
    for test in expected_failures:
        if test not in actual_results:
            errors.append(f"Expected failure but passed: {test}")

    for test in unexpected_passes:
        if test in actual_results:
            errors.append(f"Unexpected pass: {test}")

    if errors:
        for error in errors:
            print(error)
        raise Exception("Test validation failed")

if __name__ == "__main__":
    validate_test_results('test_results.xml')
