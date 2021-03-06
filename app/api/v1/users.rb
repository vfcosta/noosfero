module Api
  module V1
    class Users < Grape::API

      resource :users do

        get do
          users = select_filtered_collection_of(environment, 'users', params)
          users = users.select{|u| u.person.display_info_to? current_person}
          present users, :with => Entities::User, :current_person => current_person
        end

        get "/me" do
          authenticate!
          present current_user, :with => Entities::User, :current_person => current_person
        end

        get ":id" do
          user = environment.users.find_by id: params[:id]
          if user
            present user, :with => Entities::User, :current_person => current_person
          else
            not_found!
          end
        end

        get ":id/permissions" do
          authenticate!
          user = environment.users.find(params[:id])
          output = {}
          user.person.role_assignments.map do |role_assigment|
            if role_assigment.resource.respond_to?(:identifier) && role_assigment.resource.identifier == params[:profile]
              output[:permissions] = role_assigment.role.permissions
            end
          end
          present output
        end

        patch ":id" do
          authenticate!
          begin
            current_person.user.change_password!(params[:current_password],
                               params[:new_password],
                               params[:new_password_confirmation])
            present({ success: true })
          rescue Exception
            render_model_errors!(current_person.user.errors)
          end

        end

      end

    end
  end
end
