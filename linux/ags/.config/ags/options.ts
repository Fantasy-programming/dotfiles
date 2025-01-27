const home = `/home/${Utils.exec("whoami")}`;

export const options = {
  quicksettings: {
    // profile_picture:
    //   "https://ik.imagekit.io/rayshold/gallery/lofi-anime-boy_863013-93642.avif",
    profile_picture: `https://ik.imagekit.io/rayshold/gallery/lofi-anime-boy_863013-93642.avif`,
    screenshot: {
      path: `${home}/Pictures/Screenshots`,
    },
    random_wall: {
      path: `${home}/Pictures/wallpaper`,
    },
  },
  mpris: {
    fallback_img: "https://ik.imagekit.io/rayshold/gallery/mpris-fallback.webp",
  },
  wallpaper_picker: {
    path: `${home}/.config/rofi/.current_wallpaper`,
  },
};
