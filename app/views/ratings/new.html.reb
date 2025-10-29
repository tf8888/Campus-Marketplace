<% content_for :title, "Rate Seller" %>

<main class="page" role="main">
  <div class="page__container" style="max-width: 600px;">
    <header class="page__header">
      <h1>Rate your transaction for <%= @request.item.title %></h1>
      <p>You are rating the seller: <strong><%= @request.item.user.name %></strong></p>
    </header>

    <div class="form-card">
      <%= form_with(model: @rating, url: request_rating_path(@request)) do |f| %>
        
        <% if @rating.errors.any? %>
          <div style="color: red; margin-bottom: 1rem;">
            <h2><%= pluralize(@rating.errors.count, "error") %> prohibited this rating from being saved:</h2>
            <ul>
              <% @rating.errors.full_messages.each do |message| %>
                <li><%= message %></li>
              <% end %>
            </ul>
          </div>
        <% end %>

        <div class="form-group">
          <%= f.label :score, 'Your Rating (1=Bad, 10=Excellent)' %>
          <%= f.select :score, (1..10).to_a, { prompt: 'Select a score' }, class: 'form-control' %>
        </div>

        <div class="form-actions">
          <%= f.submit 'Submit Rating', class: 'btn btn--primary' %>
          <%= link_to 'Cancel', request_path(@request), class: 'btn btn--secondary' %>
        </div>
      <% end %>
    </div>
  </div>
</main>