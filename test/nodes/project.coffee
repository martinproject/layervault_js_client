expect  = require 'expect.js'
nock    = require 'nock'

LayerVault = require '../../lib/layervault'

describe 'Project', ->
  before ->
    @config = new LayerVault.Configuration ->
      @accessToken = 'foobar'

    @client = new LayerVault.Client(@config)
    @organization = @client.organization('ryan-lefevre')

  beforeEach -> @project = @organization.project('Test Project')
  afterEach -> nock.cleanAll()

  describe 'get', ->
    beforeEach ->
      nock(@config.apiBase)
        .get("#{@config.apiPath}#{@project.nodePath}")
        .reply(200, require('../fixtures/folder/get'))

    it 'does not error', (done) ->
      @project.get (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a response object', (done) ->
      @project.get (err, resp) ->
        expect(resp).to.be.an('object')
        expect(resp.name).to.be('Test Project')
        expect(resp.files.length).to.be(1)
        done()

    it 'applies the data to the project object', (done) ->
      @project.get (err, resp) ->
        expect(@name).to.be('Test Project')
        expect(@member).to.be(false)
        done()

    it 'correctly initializes relations', (done) ->
      @project.get (err, resp) ->
        expect(@files[0]).to.have.property('nodePath')
        expect(@files[0].get).to.be.a('function')
        done()

  describe 'create', ->
    beforeEach ->
      nock(@config.apiBase)
        .post("#{@config.apiPath}#{@project.nodePath}")
        .reply(200, require('../fixtures/folder/create'))

    it 'does not error', (done) ->
      @project.create (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a response object', (done) ->
      @project.create (err, resp) ->
        expect(resp).to.not.be(null)
        expect(resp).to.be.an('object')
        done()

    it 'applies the data to the project object', (done) ->
      @project.create (err, resp) ->
        expect(@name).to.be('Test Project')
        done()

  describe 'delete', ->
    beforeEach ->
      nock(@config.apiBase)
        .delete("#{@config.apiPath}#{@project.nodePath}")
        .reply(200, require('../fixtures/folder/delete'))

    it 'does not error', (done) ->
      @project.delete (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns success', (done) ->
      @project.delete (err, resp) ->
        expect(resp).to.not.be(null)
        expect(resp.error).to.be('success')
        done()

  describe 'move', ->
    beforeEach ->
      nock(@config.apiBase)
        .post("#{@config.apiPath}#{@project.nodePath}/move", to: 'Other Project')
        .reply(200, require('../fixtures/folder/move'))

    it 'does not error', (done) ->
      @project.move 'Other Project', (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a response object', (done) ->
      @project.move 'Other Project', (err, resp) ->
        expect(resp).to.not.be(null)
        expect(resp.name).to.be('Other Project')
        done()

    it 'updates the object with the new data', (done) ->
      @project.move 'Other Project', (err, resp) ->
        expect(@name).to.be('Other Project')
        done()

    it 'is aliased to #rename', (done) ->
      @project.rename 'Other Project', (err, resp) ->
        expect(err).to.be(null)
        expect(resp).to.be.an('object')
        done()

  describe 'changeColor', ->
    beforeEach ->
      nock(@config.apiBase)
        .put("#{@config.apiPath}#{@project.nodePath}/color", color: 'red')
        .reply(200, require('../fixtures/folder/changeColor'))

    it 'does not error', (done) ->
      @project.changeColor 'red', (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a response object', (done) ->
      @project.changeColor 'red', (err, resp) ->
        expect(resp).to.be.an('object')
        expect(resp.error).to.be('success')
        done()

