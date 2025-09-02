# app/helpers/users_helper.rb
module UsersHelper
  def avatar_tag(user, size: 32, class_name: "")
    return default_avatar(size, class_name) unless user

    if user.avatar&.attached?
      if user.avatar.variable?
        # JPEG/PNG : on redimensionne proprement
        image_tag user.avatar.variant(resize_to_fill: [size, size]),
                  width: size, height: size,
                  class: "rounded-circle #{class_name}",
                  style: "object-fit: cover;",
                  alt: user.username
      else
        # SVG ou non-transformable : on affiche tel quel
        image_tag user.avatar,
                  width: size, height: size,
                  class: "rounded-circle #{class_name}",
                  style: "object-fit: cover;",
                  alt: user.username
      end
    else
      default_avatar(size, class_name)
    end
  rescue ActiveStorage::IntegrityError, ActiveStorage::InvariableError
    # En cas de souci (fichier corrompu, mauvais type, etc.) => placeholder
    default_avatar(size, class_name)
  end

  private

  def default_avatar(size, class_name)
    image_tag "avatar_placeholder.png",
              width: size, height: size,
              class: "rounded-circle #{class_name}",
              style: "object-fit: cover;",
              alt: "avatar"
  end
end
