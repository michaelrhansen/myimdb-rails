class RelationshipsController < ApplicationController
  def create
    @relationship = Relationship.find_or_initialize_by_user_id_and_follower_id(params[:relationship][:user_id], current_user.id)
    @relationship.attributes = params[:relationship]

    respond_to do |format|
      if @relationship.save
        format.js
        format.xml  { render :xml => @relationship, :status => :created, :location => @relationship }
      else
        format.js
        format.xml  { render :xml => @relationship.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @relationship = Relationship.find(params[:id])

    respond_to do |format|
      if @relationship.has_update_access?(current_user) and @relationship.update_attributes(params[:relationship])
        format.js
        format.xml  { head :ok }
      else
        format.js
        format.xml  { render :xml => @relationship.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @relationship = current_user.following_relationships.find(params[:id])
    @relationship.destroy

    respond_to do |format|
      format.js
      format.xml  { head :ok }
    end
  end
end
