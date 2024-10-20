# #!/bin/bash

# # Path to your kitty configuration file
# KITTY_CONF="$HOME/.config/kitty/kitty.conf"

# # Define the opacity values
# OPAQUE="1.0"
# TRANSPARENT="0.85"

# # Function to toggle opacity
# toggle_opacity() {
#     if grep -q "^background_opacity" "$KITTY_CONF"; then
#         if grep -q "^background_opacity $OPAQUE" "$KITTY_CONF"; then
#             sed -i "s/^background_opacity $OPAQUE/background_opacity $TRANSPARENT/" "$KITTY_CONF"
#             echo "Changed opacity to $TRANSPARENT"
#         else
#             sed -i "s/^background_opacity $TRANSPARENT/background_opacity $OPAQUE/" "$KITTY_CONF"
#             echo "Changed opacity to $OPAQUE"
#         fi
#     else
#         echo "background_opacity $OPAQUE" >> "$KITTY_CONF"
#         echo "Added opacity setting with value $OPAQUE"
#     fi
#     echo "Reloading kitty configuration....."
#     pkill -USR1 kitty
# }

# # Call the function
# toggle_opacity


#!/bin/bash

# Define the paths to your kitty configuration files
CUSTOM_KITTY_CONF="$HOME/.dotfiles/kitty/.config/kitty/kitty.conf"
DEFAULT_KITTY_CONF="$HOME/.config/kitty/kitty.conf"

# Define the opacity values
OPAQUE="1.0"
TRANSPARENT="0.85"

# Determine the configuration file to use
if [ -f "$CUSTOM_KITTY_CONF" ]; then
    KITTY_CONF="$CUSTOM_KITTY_CONF"
    echo "Using custom kitty configuration file: $KITTY_CONF"
else
    KITTY_CONF="$DEFAULT_KITTY_CONF"
    echo "Using default kitty configuration file: $KITTY_CONF"
fi

# Function to toggle opacity
toggle_opacity() {
    if grep -q "^background_opacity" "$KITTY_CONF"; then
        if grep -q "^background_opacity $OPAQUE" "$KITTY_CONF"; then
            sed -i "s/^background_opacity $OPAQUE/background_opacity $TRANSPARENT/" "$KITTY_CONF"
            echo "Changed opacity to $TRANSPARENT"
        else
            sed -i "s/^background_opacity $TRANSPARENT/background_opacity $OPAQUE/" "$KITTY_CONF"
            echo "Changed opacity to $OPAQUE"
        fi
    else
        echo "background_opacity $OPAQUE" >> "$KITTY_CONF"
        echo "Added opacity setting with value $OPAQUE"
    fi

    echo "Reloading kitty configuration....."

    # Send the SIGUSR1 signal to all running kitty instances
    pkill -USR1 kitty
}

# Call the function
toggle_opacity
