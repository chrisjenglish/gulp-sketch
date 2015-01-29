should = require 'should'
sketch = require '../coffee/'
gutil  = require 'gulp-util'
fs     = require 'fs'
path   = require 'path'

createVinyl = (file_name, contents) ->
  base = path.join __dirname, 'fixtures'
  filePath = path.join base, file_name

  new gutil.File
    cwd: __dirname
    base: base
    path: filePath
    contents: contents || fs.readFileSync filePath

describe 'gulp-sketch', () ->
  describe 'sketch()', () ->

    @timeout 10000

    it 'should emit error when file isStream()', (done) ->
      stream = sketch()
      streamFile =
        isNull: () -> false
        isStream: () -> true
      stream.on 'error', (err) ->
        err.message.should.equal 'Streaming not supported'
        done()
      stream.write streamFile

    it 'should export single svg file', (done) ->
      src = createVinyl 'flat.sketch'
      stream = sketch
        export: 'slices'
        formats: 'svg'
      stream.on 'data', (dist) ->
        should.exist dist
        should.exist dist.path
        should.exist dist.relative
        should.exist dist.contents
        dist.path.should.equal path.join __dirname, 'fixtures', 'yellow.svg'
        actual = dist.contents.toString 'utf8'
        expected = fs.readFileSync path.join(__dirname, 'expect', 'yellow.svg'), 'utf8'
        actual.should.equal expected
        done()
      stream.write src

    it 'should export single svg file under subdirectory', (done) ->
      src = createVinyl 'subdir.sketch'
      stream = sketch
        export: 'slices'
        formats: 'svg'
      stream.on 'data', (dist) ->
        should.exist dist
        should.exist dist.path
        should.exist dist.relative
        should.exist dist.contents
        dist.path.should.equal path.join __dirname, 'fixtures', 'square', 'yellow.svg'
        actual = dist.contents.toString 'utf8'
        expected = fs.readFileSync path.join(__dirname, 'expect', 'square-yellow.svg'), 'utf8'
        actual.should.equal expected
        done()
      stream.write src

    it 'should export JSON file', (done) ->
      src = createVinyl 'flat.sketch'
      stream = sketch
        export: 'slices'
        formats: 'svg'
        outputJSON: 'output.json'
      stream.on 'data', (dist) ->
        should.exist dist
        should.exist dist.path
        should.exist dist.relative
        should.exist dist.contents
        if /output\.json$/.test dist.path
          dist.path.should.equal path.join __dirname, 'fixtures', 'output.json'
          actual = dist.contents.toString 'utf8'
          expected = fs.readFileSync path.join(__dirname, 'expect', 'output.json'), 'utf8'
          actual.should.equal expected
          done()
      stream.write src

    ###
    it 'should export single png file', (done) ->
      src = createVinyl 'flat.sketch'
      stream = sketch
        export: 'slices'
        formats: 'png'
        saveForWeb: true
      stream.on 'data', (dist) ->
        should.exist dist
        should.exist dist.path
        should.exist dist.relative
        should.exist dist.contents
        dist.path.should.equal path.join __dirname, 'fixtures', 'yellow.png'
        actual = dist.contents.toString 'hex'
        expected = fs.readFileSync path.join(__dirname, 'expect', 'yellow.png'), 'hex'
        actual.should.equal expected
        done()
      stream.write src

    it 'should export single png file under subdirectory', (done) ->
      src = createVinyl 'subdir.sketch'
      stream = sketch
        export: 'slices'
        formats: 'png'
        saveForWeb: true
      stream.on 'data', (dist) ->
        should.exist dist
        should.exist dist.path
        should.exist dist.relative
        should.exist dist.contents
        dist.path.should.equal path.join __dirname, 'fixtures', 'square', 'yellow.png'
        actual = dist.contents.toString 'hex'
        expected = fs.readFileSync path.join(__dirname, 'expect', 'yellow.png'), 'hex'
        actual.should.equal expected
        done()
      stream.write src
    ###