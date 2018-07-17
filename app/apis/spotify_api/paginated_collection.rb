class SpotifyApi::PaginatedCollection < ActiveResource::Collection

  attr_accessor :paginatable_array, :prev_page, :next_page

  def initialize(parsed = {})
    @parsed = parsed
    @elements = parsed['items']
    @prev_page = parsed['previous']
    @next_page = parsed['next']
    setup_paginatable_array(parsed)
  end

  def setup_paginatable_array(parsed)
    @paginatable_array ||= begin
      options = {
        limit: parsed['limit'].try(:to_i),
        offset: parsed['offset'].try(:to_i),
        total_count: parsed['total'].try(:to_i)
      }

      Kaminari::PaginatableArray.new(elements, options)
    end
  end

  def prev
    return nil unless prev_page
    @prev ||= begin
      r = resource_class.find(:all, from: prev_page)
      # r = resource_class.all(params: {offset: offset_value - limit_value, limit: limit_value})
      r.instance_variable_set(:@next, self)
      r
    end
  end

  def next
    return nil unless next_page
    @next ||= begin
      r = resource_class.find(:all, from: next_page)
      # r = resource_class.all(params: {offset: offset_value + limit_value, limit: limit_value})
      r.instance_variable_set(:@prev, self)
      r
    end
  end

  def find_each
    c = self
    while(1)
      yield c.elements
      break if (c = c.next).nil?
    end
  end

  private

  UNSUPPORTED_KAMINARI_METHODS = %w(page limit per padding)
  def method_missing(method, *args, &block)
    if !method.to_s.in?(UNSUPPORTED_KAMINARI_METHODS) && paginatable_array.respond_to?(method)
      paginatable_array.send(method)
    else
      super
    end
  end
end