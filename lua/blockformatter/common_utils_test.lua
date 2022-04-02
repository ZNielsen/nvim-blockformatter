describe("Common Utils Unit Tests", function()
    local utils = require "common_utils"

    it ("should find prefixes", function()
        local result

        result = utils.leads_with("a test string", "a test")
        assert.are.equal(true, result)

        result = utils.leads_with("a test string", "un test")
        assert.are.equal(false, result)

        result = utils.leads_with("a test string", "a teest")
        assert.are.equal(false, result)

        result = utils.leads_with("a test string", "a teest")
        assert.are.equal(false, result)

        result = utils.leads_with("<!-- a test string -->", "<!--")
        assert.are.equal(true, result)

        result = utils.leads_with("/* a test string */", "/*")
        assert.are.equal(true, result)

        result = utils.leads_with("/* a test string */", "*/")
        assert.are.equal(false, result)

        result = utils.leads_with("// a test string ", "//")
        assert.are.equal(true, result)

        result = utils.leads_with("", "")
        assert.are.equal(true, result)
    end)

    it ("should find suffixes", function()
        local result

        result = utils.ends_with("a test string", "string")
        assert.are.equal(true, result)

        result = utils.ends_with("a test string", "un test")
        assert.are.equal(false, result)

        result = utils.ends_with("a test string", " string")
        assert.are.equal(true, result)

        result = utils.ends_with("a test string ", "g ")
        assert.are.equal(true, result)

        result = utils.ends_with("", "")
        assert.are.equal(true, result)

        result = utils.ends_with(" ", " ")
        assert.are.equal(true, result)

        result = utils.ends_with("<!-- a test string -->", "-->")
        assert.are.equal(true, result)

        result = utils.ends_with("/* a test string */", "/*")
        assert.are.equal(false, result)

        result = utils.ends_with("/* a test string */", "*/")
        assert.are.equal(true, result)

        result = utils.ends_with("// a test string ", "//")
        assert.are.equal(false, result)
    end)
end)

