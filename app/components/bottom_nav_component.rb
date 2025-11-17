# frozen_string_literal: true

class BottomNavComponent < ViewComponent::Base
  def initialize(current_user:)
    @current_user = current_user
  end

  erb_template <<-ERB
    <nav class="fixed bottom-0 left-0 right-0 md:hidden z-50 bg-base-100 border-t border-base-300 pb-[env(safe-area-inset-bottom)]">
      <div class="dock dock-m" data-controller="dock">
        <% if @current_user.has_permission?("read_dashboard") %>
          <%= link_to admin_dashboard_index_path,
              data: { turbo_frame: "main", turbo_action: "advance", dock_target: "link" } do %>
            <i class="fas fa-chart-line size-[1.2em]"></i>
            <span class="dock-label text-xs"><%= t("sidebar.dashboard") %></span>
          <% end %>
        <% end %>

        <%= link_to training_sessions_path,
            data: { turbo_frame: "main", turbo_action: "advance", dock_target: "link" } do %>
          <i class="fas fa-bolt size-[1.2em]"></i>
          <span class="dock-label text-xs"><%= t("sidebar.trainings") %></span>
        <% end %>

        <% if @current_user.has_permission?("read_exercise") %>
          <%= link_to admin_exercises_path,
              data: { turbo_frame: "main", turbo_action: "advance", dock_target: "link" } do %>
            <i class="fas fa-dumbbell size-[1.2em]"></i>
            <span class="dock-label text-xs"><%= t("sidebar.exercises") %></span>
          <% end %>
        <% end %>

        <% if @current_user.has_permission?("read_user") %>
          <%= link_to admin_users_path, data: { turbo_frame: "main", turbo_action: "advance", dock_target: "link" } do %>
            <i class="fas fa-users size-[1.2em]"></i>
            <span class="dock-label text-xs"><%= t("sidebar.users") %></span>
          <% end %>
        <% end %>

        <% if @current_user.has_permission?("read_role") %>
          <%= link_to admin_roles_path,
              data: { turbo_frame: "main", turbo_action: "advance", dock_target: "link" } do %>
            <i class="fas fa-user-shield size-[1.2em]"></i>
            <span class="dock-label text-xs"><%= t("sidebar.roles") %></span>
          <% end %>
        <% end %>
      </div>
    </nav>
  ERB
end
