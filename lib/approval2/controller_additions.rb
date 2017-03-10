module Approval2
  module ControllerAdditions
    extend ActiveSupport::Concern

    included do
      before_filter :before_edit, only: :edit
      before_filter :before_approve, only: :approve
      before_filter :before_index, only: :index
    end


    private 

    def before_index
      if (params[:approval_status].present? and params[:approval_status] == 'U')      
        modelName = self.class.name.sub("Controller", "").underscore.split('/').last.singularize
        modelKlass = modelName.classify.constantize

        x = modelKlass.unscoped.where("approval_status =?",'U').order("id desc")
        instance_variable_set("@#{modelName}s", x.paginate(:per_page => 10, :page => params[:page]))
      end
    end

    def before_edit
      modelName = self.class.name.sub("Controller", "").underscore.split('/').last.singularize
      modelKlass = modelName.classify.constantize

      x = modelKlass.unscoped.find_by_id(params[:id])
      if x.approval_status == 'A' && x.unapproved_record.nil?
        params = (x.attributes).merge({:approved_id => x.id,:approved_version => x.lock_version})
        x = modelKlass.new(params)
      end

      instance_variable_set("@#{modelName}", x)
    end

    def before_approve
      modelName = self.class.name.sub("Controller", "").underscore.split('/').last.singularize
      modelKlass = modelName.classify.constantize

      x = modelKlass.unscoped.find(params[:id]) rescue nil
      modelKlass.transaction do
        approval = x.approve
        if approval.empty?
          flash[:alert] = "#{modelName.humanize.titleize} record was approved successfully"
        else
          msg = x.errors.full_messages << approval
          flash[:alert] = msg
          raise ActiveRecord::Rollback
        end
      end
    end    
  end
end

# ActionController::Base.class_eval do
  # include Approval2::ControllerAdditions
# end
