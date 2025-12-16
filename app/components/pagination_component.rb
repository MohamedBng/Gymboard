class PaginationComponent < ViewComponent::Base
  attr_reader :collection

  def initialize(collection:)
    @collection = collection
  end

  erb_template <<-ERB
    <% if collection.total_pages > 1 %>
      <div class="join flex justify-center mt-4">
        <%= link_to_prev_page collection, '«', class: "join-item btn" %>
        <button class="join-item btn">Page <%= collection.current_page %></button>
        <%= link_to_next_page collection, '»', class: "join-item btn" %>
      </div>
    <% end %>
  ERB
end
