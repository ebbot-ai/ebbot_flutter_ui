# Styling and Theming

Learn about the limited styling options available for the Ebbot chat widget.

## Overview

The Ebbot Flutter UI widget uses [flutter_chat_ui](https://docs.flyer.chat/flutter/chat-ui/) internally, but theme customization is not currently exposed through the configuration API.

## Available Customization

Currently, the only styling customization available is for rating icons.

## Custom Rating Icons

Replace the default star rating icons with custom widgets:

```dart
final ratingSelected = Icon(
  Icons.thumb_up,
  color: Colors.green,
  size: 30,
);

final ratingUnselected = Icon(
  Icons.thumb_up_outlined,
  color: Colors.grey,
  size: 30,
);

final configuration = EbbotConfigurationBuilder()
  .chat(
    EbbotChatBuilder()
      .rating(ratingUnselected)
      .ratingSelected(ratingSelected)
      .build()
  )
  .build();
```

### Using Images as Rating Icons

```dart
final ratingSelected = Image.asset(
  'assets/icons/star_filled.png',
  width: 30,
  height: 30,
);

final ratingUnselected = Opacity(
  opacity: 0.5,
  child: Image.asset(
    'assets/icons/star_outline.png',
    width: 30,
    height: 30,
  ),
);

final configuration = EbbotConfigurationBuilder()
  .chat(
    EbbotChatBuilder()
      .rating(ratingUnselected)
      .ratingSelected(ratingSelected)
      .build()
  )
  .build();
```

## Important Notes

- Rating icons should be sized to fit within 30x30 pixels
- Both `rating` (unselected) and `ratingSelected` (selected) states must be provided
- The widget automatically handles the selection state

## Limitations

Currently, the following styling options are **not available**:

- Custom chat themes or colors
- Font customization
- Message bubble styling
- Background colors
- Avatar customization
- Typing indicator styling

## Future Enhancements

Theme customization may be added in future versions. For now, the chat uses the default flutter_chat_ui styling.

## Best Practices

1. **Icon Consistency**: Use consistent icon styles that match your app's design
2. **Size Constraints**: Keep rating icons within the 30x30 pixel recommendation
3. **Accessibility**: Ensure sufficient contrast for both selected and unselected states
4. **Brand Alignment**: Choose icons that align with your brand's feedback approach

## Next Steps

- Configure [User Attributes](./user-attributes.md)
- Set up [Chat Behavior](./behavior.md)
- Add [Event Callbacks](./callbacks.md)

## Troubleshooting

If your rating icons aren't appearing:

1. Ensure both `rating` and `ratingSelected` are provided
2. Check that widgets are properly sized
3. Verify the configuration is passed to the widget
4. Test with simple Icon widgets first

For more help, see the [Troubleshooting Guide](./troubleshooting.md).