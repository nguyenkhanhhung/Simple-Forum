class RepliesController < ApplicationController
  before_filter  :load_topic  
  skip_before_filter :authorize, :only => [:index]
  skip_before_filter :admin_required
  # GET /replies
  # GET /replies.xml
  def index
    # Get the current topic information
    @topic = Topic.find_by_id(params[:topic_id], :joins => "left outer join users on users.id = topics.user_id", :select => "users.*, topics.*")
    
    # Get the forum of current topic
    @forum = Forum.find(@topic.forum_id)

    # Get total posts for the user who is owner of the topic
    @users_and_total_posts = {}
    @users_and_total_posts[@topic.user_id] = User.find(@topic.user_id, :joins => "left outer join replies on replies.user_id = users.id", :select => "users.*, count(replies.id) as posts_count", :group => "users.id") 

    # Get replies of current topic
    @replies = Reply.find_all_by_topic_id(params[:topic_id])

    # Get total posts for the users who reply the topic    
    @replies.each do |reply|
      if @users_and_total_posts.has_key?(reply.user_id) == false 
        @users_and_total_posts[reply.user_id] = User.find(reply.user_id, :joins => "left outer join replies on replies.user_id = users.id", :select => "users.*, count(replies.id) as posts_count", :group => "users.id") 
      end
    end  
    
    # Update view
    @topic.update_attribute(:view, @topic.view + 1)

    respond_to do |format|
      format.html # findreplies.html.erb
      format.xml  { render :xml => @replies }
    end
  end

  # GET /replies/1
  # GET /replies/1.xml
  def show
    @reply = Reply.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reply }
    end
  end

  # GET /replies/new
  # GET /replies/new.xml
  def new
    @reply = Reply.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reply }
    end
  end

  # GET /replies/1/edit
  def edit
    @reply = Reply.find(params[:id])
  end

  # POST /replies
  # POST /replies.xml
  def create
    @reply = Reply.new(params[:reply])
    @reply.topic_id = params[:topic_id]
    respond_to do |format|
      @reply.user_id = session[:user_id]
      if @reply.save
        format.html { redirect_to "/topics/#{@reply.topic_id}/replies"}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reply.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /replies/1
  # PUT /replies/1.xml
  def update
    @reply = Reply.find(params[:id])

    respond_to do |format|
      if @reply.update_attributes(params[:reply])
        format.html { redirect_to(@reply, :notice => 'Reply was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reply.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /replies/1
  # DELETE /replies/1.xml
  def destroy
    @reply = Reply.find(params[:id])
    @reply.destroy

    respond_to do |format|
      format.html { redirect_to(replies_url) }
      format.xml  { head :ok }
    end
  end
  
  private 
    def load_topic
      @topic = Topic.find(params[:topic_id])
    end
end
