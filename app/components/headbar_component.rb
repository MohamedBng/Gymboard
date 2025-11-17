# frozen_string_literal: true

class HeadbarComponent < ViewComponent::Base
  attr_reader :current_user

  erb_template <<-ERB
    <header class="navbar bg-base-100 shadow-sm sticky top-0 z-10" data-controller="headbar">
      <div class="flex-1 flex items-center gap-4">
        <button type="button" class="btn btn-ghost btn-sm hidden md:flex" data-action="headbar#toggleSidebar">
          <i class="fas fa-bars text-2xl"></i>
        </button>
        <%= link_to root_path, class: 'md:hidden flex items-center' do %>
          <%= image_tag 'logo.png', alt: 'Logo', class: 'h-8 w-8' %>
        <% end %>
      </div>
       <div class="dropdown dropdown-end">
        <div tabindex="0" role="button" class="btn btn-ghost btn-circle avatar">
          <%= render(UserAvatarComponent.new(user: current_user, size: 30)) %>
        </div>
        <ul
          tabindex="0"
          class="menu menu-sm dropdown-content bg-base-100 rounded-box z-1 mt-3 w-52 p-2 shadow">
          <li><%= link_to "Profile", admin_user_path(current_user), data: { turbo_frame: "main", turbo_action: "advance" } %></li>
          <li><%= button_to "Logout", destroy_user_session_path, method: :delete %></li>
        </ul>
      </div>
    </header>
  ERB

  def initialize(current_user:)
    @current_user = current_user
  end
end
