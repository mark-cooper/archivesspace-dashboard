require "sinatra/base"
require "archivesspace/client"
require "json"

# APP CACHES RESULTS IN MEMORY -- RESTART TO CLEAR
$config = JSON.parse( IO.read( 'config.ini' ) )

class App < Sinatra::Base

  configure do
    set :backend , ArchivesSpace::Client.new( { site: "http://#{$config["host"]}:#{$config["port"]}" } )
    set :repo    , nil
    set :perms   , nil
    set :groups  , nil
  end

  error do
    'The application encountered an error.'
  end

  # TODO: CATCH CONNECTION ERROR
  before do
    @backend            = settings.backend
    @backend.user       = $config["user"]
    @backend.password   = $config["pass"]
    @backend.login

    settings.repo   = @backend.repositories.find { |r| r.repo_code =~ /#{$config["repo"]}/i } unless settings.repo
    raise "REPOSITORY NOT FOUND USING CODE: #{$config["repo"]}" if settings.repo.nil?
    settings.perms  = @backend.permissions("all") unless settings.perms
    settings.groups = @backend.groups(settings.repo) unless settings.groups
    
    @p = {}
    settings.perms.each do |p|
      @p[p.permission_code] = {} unless @p.has_key? p.permission_code
      @p[p.permission_code][:description] = p.description.split(":")[0]
      @p[p.permission_code][:level]       = p.level
      @p[p.permission_code][:uri]         = p.uri
    end

    @g = {}
    settings.groups.each do |g|
      @g[g.group_code] = {} unless @g.has_key? g.group_code
      @g[g.group_code][:description] = g.description.split(":")[0]
      @g[g.group_code][:permissions] = g.grants_permissions
    end
  end

  get "/" do
    @ver = @backend.version
    erb :index, layout: true
  end

  get "/perms" do
    erb :perms, layout: true   
  end

  get "/roles" do
    erb :roles, layout: true
  end

end
