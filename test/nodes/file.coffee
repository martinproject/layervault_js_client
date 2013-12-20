expect  = require 'expect.js'
nock    = require 'nock'

LayerVault = require '../../lib/layervault'

describe 'File', ->
  before ->
    @config = new LayerVault.Configuration ->
      @accessToken = 'foobar'

    @client = new LayerVault.Client(@config)
    @organization = @client.organization('ryan-lefevre')

  beforeEach -> @file = @organization.file('Test Project', 'test.psd')

  describe 'get', ->
    beforeEach ->
      nock(@config.apiBase)
        .get("#{@config.apiPath}#{@file.nodePath}")
        .reply(200, require('../fixtures/file/get'))

    it 'does not error', (done) ->
      @file.get (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a response object', (done) ->
      @file.get (err, resp) ->
        expect(resp).to.be.an('object')
        expect(resp.name).to.be('test.psd')
        done()

    it 'applies the data to the file object', (done) ->
      @file.get (err, resp) ->
        expect(@name).to.be('test.psd')
        done()

    it 'correctly initializes relations', (done) ->
      @file.get (err, resp) ->
        expect(@revisions.length).to.be(2)
        expect(@revisions[0].name).to.be('1')
        expect(@revisions[0].nodePath).to.be('/ryan-lefevre/Test%20Project/test.psd/1')
        expect(@revisions[0].get).to.be.a('function')
        done()


