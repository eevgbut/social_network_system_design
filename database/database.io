Table posts {
  id             uuid [pk]
  user_id        uuid [not null]
  description    text
  geo_tag        json    // [{latitude: 43.25667, longitude: 42.84556, place_name: "Эльбрус"}, ...]
  geo_hash       varchar // хеш квадрата с точноcтью детализации до среднего настеленного пункта
  image_urls     text[]
  rating decimal [default: 0]
  ratings_count  integer [default: 0] // кол-во чтений постов сильно больше кол-ва созаний постов, поэтому rating пересчитывем при сохранении оценок по мере их накопления (не на каждую оценку)
  comments_count integer [default: 0] // инкрементируем при сохранении комментариев

  created_at timestamp
  updated_at timestamp
}

// отдельная таблица (прибегаем к денормализации) чтобы не выполнять сложные запросы к таблице постов в момент отрисовки гео-раздела
Table places {
  hash      varchar [not null] // хеш квадрата
  name      varchar [not null]
  num_posts integer [increment, not null]

  created_at timestamp
  updated_at timestamp
}

Table ratings {
  hash    varchar [pk]
  user_id uuid    [not null]
  post_id uuid    [not null]
  rating  integer [not null]

  created_at timestamp
  updated_at timestamp
}

Table comments {
  id          uuid [pk]
  user_id     uuid [not null]
  post_id     uuid [not null]
  description text [not null]

  created_at timestamp
  updated_at timestamp
}

Table follows {
  id uuid [pk]
  follower_id  uuid [not null]
  following_id uuid [not null]

  updated_at timestamp
}

Table users {
  id              uuid    [pk]
  first_name      varchar [not null]
  last_name       varchar [not null]
  email           varchar [unique, not null]
  username        varchar [unique, not null]
  avatar_url      text
  followers_count integer [default: 0]
  following_count integer [default: 0]
}

Ref: posts.user_id > users.id

Ref: ratings.user_id > users.id
Ref: ratings.post_id > posts.id

Ref: comments.user_id > users.id
Ref: comments.post_id > posts.id

Ref: follows.follower_id > users.id
Ref: follows.following_id > users.id

Ref: posts.geo_hash > places.hash