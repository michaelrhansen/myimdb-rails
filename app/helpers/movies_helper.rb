module MoviesHelper
  def remote_review_url(review)
    review_type = review.dom_class
    identifier  = "review-source-#{review_type}-#{@movie.id}"

    content_tag(:p, :id=> identifier) do
      review.resource_url
    end + javascript_tag("$('##{ identifier }').editable('#{ send("movie_#{review_type}_path", @movie) }', { ajaxoptions: { dataType : 'script' } });")
  end
  
  def searching?
    !!params[:q].try(:strip)
  end
end
