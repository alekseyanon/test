node(:date){|c| Russian::strftime(c.created_at, '%d %B %Yг.')}
