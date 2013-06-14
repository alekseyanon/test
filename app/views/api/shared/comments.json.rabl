node(:comments_count) do |r|
  "#{r.comments.count.to_s} #{Russian.p(r.comments.count, 'коментарий', 'коментария', 'коментариев')}"
end
