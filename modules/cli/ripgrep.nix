{ ... }: {
  programs.ripgrep = {
    enable = true;

    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!.git/*"
      "--no-binary"
      "--pretty"
      "--max-columns=150"
      "--max-columns-preview"

      # Type shortcuts
      "--type-add=conf:*rc,*init,*.{conf,config}"
      "--type-add=csv:*.{txt,csv,tsv}*"
      "--type-add=image:*.{avif,bmp,dns,heic,heif,gif,jpg,jpeg,png,raw,tiff}"
      "--type-add=shell:*.{sh,bash,fish,zsh}"
      "--type-add=text:*.{md,mdown,markdown,mkdn,textile,rst,txt}*"
      "--type-add=web:*.{html,css,js,jsx,ts,tsx}*"
    ];
  };
}
