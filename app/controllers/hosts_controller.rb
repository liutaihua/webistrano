class HostsController < ApplicationController
  before_filter :ensure_admin, :only => [:new, :edit, :destroy, :create, :update]
  
  # GET /hosts
  # GET /hosts.xml
  def index
    @hosts = current_project ? current_project.hosts : nil

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @hosts.to_xml }
    end
  end

  # GET /hosts/1
  # GET /hosts/1.xml
  def show
    @host = Host.find(params[:id])
    @stages = @host.stages.uniq.sort_by{|x| x.project.name}
    @ips = @host.content.split

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @host.to_xml }
    end
  end

  # GET /hosts/new
  def new
    @host = Host.new
  end

  # GET /hosts/1;edit
  def edit
    @host = Host.find(params[:id])
  end

  # POST /hosts
  # POST /hosts.xml
  def create
=begin
    err = false
    params[:host][:name].split.each do |ip|
      @host = Host.new(:name => ip)
      unless @host.save
        err = true
        render :action => 'new'
        break
      end
    end
    unless err
      flash[:notice] = 'Host was successfully created.'
      redirect_to host_url(@host)
    end
=end
    @host = Host.new(params[:host])
    @host.project_id = session[:pid]
    
    respond_to do |format|
      if @host.save
#        gen_ipfiles(params[:host])
        flash[:notice] = 'Host List was successfully created.'
        format.html { redirect_to host_url(@host) }
        format.xml  { head :created, :location => host_url(@host) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @host.errors.to_xml }
      end
    end

  end

  # PUT /hosts/1
  # PUT /hosts/1.xml
  def update
    @host = Host.find(params[:id])

    respond_to do |format|
      if @host.update_attributes(params[:host])
#        gen_ipfiles(params[:host])
        flash[:notice] = 'Host was successfully updated.'
        format.html { redirect_to host_url(@host) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @host.errors.to_xml }
      end
    end
  end

  # DELETE /hosts/1
  # DELETE /hosts/1.xml
  def destroy
    @host = Host.find(params[:id])
#    myfn = "/var/ipfiles/#{@host.name}"
#    File.delete(myfn) if File.exists?(myfn)
    @host.destroy
    

    respond_to do |format|
      flash[:notice] = 'Host was successfully deleted.'
      format.html { redirect_to hosts_url }
      format.xml  { head :ok }
    end
  end
#
#  protected
#
#  def gen_ipfiles(host)
#    open("/var/ipfiles/#{host[:name]}", "w") do |f|
#      f.write host[:content]
#    end
#  end
#
end
