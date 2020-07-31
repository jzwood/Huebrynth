# Nested Records

https://www.reddit.com/r/elm/comments/b2f7f6/any_plans_for_nested_record_syntax/
Extreme nesting is discouraged.

For simple nesting you can extract the relevant records in the parameters of the function:

```elm
update msg ({ menu } as model) =
    case msg of
        UpdateMenuTitle title ->
            ({model | menu = { menu | title = title}}, Cmd.none)
```

