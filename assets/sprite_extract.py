from PIL import Image

def remove_background(image_path, output_path, threshold=10):
    """
    Remove the background of a sprite sheet where the background color is assumed
    to be the color of the top-left corner pixel.

    Parameters:
    - image_path: str, path to the input image file.
    - output_path: str, path where the output image will be saved.
    - threshold: int, the threshold to consider a pixel as background (default 10).

    Returns:
    - output_path: str, the path to the output image with a transparent background.
    """
    # Load the image
    sprite_sheet = Image.open(image_path)

    # Convert the image to RGBA if it's not already in that mode
    sprite_sheet = sprite_sheet.convert("RGBA")

    # Data of the image
    datas = sprite_sheet.getdata()

    # The background color to be made transparent (R, G, B)
    # Obtained from the top-left corner pixel of the sprite sheet
    background_color = datas[0][:3]

    # New data after removing the background
    new_data = []

    # Loop through each pixel and replace the background color with a transparent one
    for item in datas:
        # Change pixels that match the background color to transparent
        if all(abs(item[i] - background_color[i]) <= threshold for i in range(3)):
            new_data.append((255, 255, 255, 0))
        else:
            new_data.append(item)

    # Update image data
    sprite_sheet.putdata(new_data)

    # Save the updated image
    sprite_sheet.save(output_path)

    return output_path

output_path = remove_background("C:/Users/abrah/Documents/Godot/Projects/Pokemon_Fire_Red/assets/AnimatedGrass.png", "GrassAnimated.png")
