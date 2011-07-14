class TopicsController < ApplicationController
  # GET /topics
  # GET /topics.xml
  before_filter  :load_forum
  skip_before_filter :authorize, :only => [:index]
  skip_before_filter :admin_required, :only => [:index]
  def index
    @forum = Forum.find(params[:forum_id])
    @topics = Topic.find_all_by_forum_id(params[:forum_id])  
    @last_replies = {}    
    @total_replies = {}
    @total_view = {}
    @topics.each do |topic|
      # Get last reply for each topic
      @last_replies[topic.id] = Reply.find(:first, :conditions => [ "topic_id = ?", topic.id], :order => "created_at DESC")    
    
      # Get total replies for each topic
      @total_replies[topic.id] = Reply.count(:conditions => [ "topic_id = ?", topic.id])    
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = Topic.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])
    @topic.user_id = session[:user_id]
    @topic.view = 0
    @topic.forum_id = params[:forum_id]  
    respond_to do |format|       
      if @topic.save
        format.html { redirect_to "/forums/#{@topic.forum_id.to_s}/topics"}
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end 

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to(@topic, :notice => 'Topic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end
  
  private 
    def load_forum
      @forum = Forum.find(params[:forum_id])
    end 
end
