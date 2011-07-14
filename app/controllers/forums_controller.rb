class ForumsController < ApplicationController
  skip_before_filter :authorize, :only => [:index]
  skip_before_filter :admin_required, :only => [:index]
  # GET /forums
  # GET /forums.xml
  def index
    @forums = Forum.all
    @last_replies = {}
    @total_topics = {}
    @total_replies = {}
    @forums.each do |forum|
      topics_list = Topic.all(:conditions => [ "forum_id = ?", forum.id])      
      topics = []      
      topics_list.each do |t|
        topics << t.id
      end

      # Get last reply for each forum
      @last_replies[forum.id] = Reply.find(:first, :conditions => [ "topic_id IN (?)", topics], :joins => "left outer join users on users.id = replies.user_id", :select => "users.*, replies.*", :order => "created_at DESC")

      # Get total topics for each forum
      @total_topics[forum.id] = Topic.count(:conditions => ["forum_id = ?", forum.id])

      # Get total replies for each forum
      if topics != nil
        @total_replies[forum.id] = Reply.count(:conditions => ["topic_id IN (?)", topics])
      else
        @total_replies[forum.id] = 0
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forums }
    end
  end

  # GET /forums/1
  # GET /forums/1.xml
  def show
    @forum = Forum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forum }
    end
  end
  
  # GET /forums/new
  # GET /forums/new.xml
  def new
    @forum = Forum.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forum }
    end
  end

  # GET /forums/1/edit
  def edit
    @forum = Forum.find(params[:id])
  end

  # POST /forums
  # POST /forums.xml
  def create
    @forum = Forum.new(params[:forum])

    respond_to do |format|
      if @forum.save
        format.html { redirect_to(:controller => 'forums', :action => 'index', :notice => 'Forum was successfully created.') }
        format.xml  { render :xml => @forum, :status => :created, :location => @forum }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forums/1
  # PUT /forums/1.xml
  def update
    @forum = Forum.find(params[:id])

    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        format.html { redirect_to(@forum, :notice => 'Forum was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.xml
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to(forums_url) }
      format.xml  { head :ok }
    end
  end
end
