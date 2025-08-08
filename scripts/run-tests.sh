#!/bin/bash

echo "🧪 Running tests for DevOps Pipeline..."

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -e "${YELLOW}Running: $test_name${NC}"
    
    if eval "$test_command"; then
        echo -e "${GREEN}✅ PASSED: $test_name${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAILED: $test_name${NC}"
        ((TESTS_FAILED++))
    fi
    echo ""
}

# Test 1: Check if Dockerfile exists
run_test "Dockerfile exists" "[ -f my-app/Dockerfile ]"

# Test 2: Check if HTML file exists
run_test "Dashboard HTML exists" "[ -f my-app/index.html ]"

# Test 3: Validate HTML syntax (basic check)
run_test "HTML syntax check" "grep -q '<!DOCTYPE html>' my-app/index.html"

# Test 4: Docker build test
run_test "Docker build test" "cd my-app && docker build -t test-dashboard . > /dev/null 2>&1"

# Test 5: Container startup test
run_test "Container startup test" "docker run -d -p 8081:80 --name temp-test test-dashboard > /dev/null 2>&1 && sleep 3 && docker stop temp-test > /dev/null 2>&1 && docker rm temp-test > /dev/null 2>&1"

# Clean up test images
docker rmi test-dashboard > /dev/null 2>&1

# Summary
echo "=========================="
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo "=========================="

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}💥 Some tests failed!${NC}"
    exit 1
fi
