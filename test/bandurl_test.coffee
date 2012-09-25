bandurl = require('../lib/bandurl.js')

# ======== A Handy Little Nodeunit Reference ========
#   https://github.com/caolan/nodeunit
# 
#   Test methods:
#     test.expect(numAssertions)
#     test.done()
#   Test assertions:
#     test.ok(value, [message])
#     test.equal(actual, expected, [message])
#     test.notEqual(actual, expected, [message])
#     test.deepEqual(actual, expected, [message])
#     test.notDeepEqual(actual, expected, [message])
#     test.strictEqual(actual, expected, [message])
#     test.notStrictEqual(actual, expected, [message])
#     test.throws(block, [error], [message])
#     test.doesNotThrow(block, [error], [message])
#     test.ifError(value)

exports['tracks'] =
  setUp: (done) ->
    done()
    
  'works': (test) ->
    test.expect(1)
    bandurl.tracks 'massy ferguson', (tracks)->
      console.log tracks
      titles = title for title, track of tracks
      test.ok titles.length > 0, 'should have tracks'
      test.done()
