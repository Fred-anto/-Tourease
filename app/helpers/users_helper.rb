module UsersHelper
  def avatar_tag(user, size: 32, class_name: "")
    if user&.avatar&.attached?
      image_tag user.avatar.variant(resize_to_fill: [size, size]).processed,
                width: size, height: size,
                class: "rounded-circle #{class_name}",
                alt: user.username
      # Pour Cloudinary directement il faut décommenter si vous voulez guys :
      # cl_image_tag user.avatar.key, width: size, height: size, crop: :thumb, gravity: :face,
      #              class: "rounded-circle #{class_name}", alt: user.username
    else
      image_tag "placeholder.svg",
                width: size, height: size,
                class: "rounded-circle #{class_name}",
                alt: user&.username || "user"
    end
  end
end
