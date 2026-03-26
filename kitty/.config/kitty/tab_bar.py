def draw_title(data: dict) -> str:
    fmt = data["fmt"]
    bell_symbol = data["bell_symbol"]
    activity_symbol = data["activity_symbol"]
    index = data["index"]
    title = data["title"]

    prefix = f"{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{fmt.fg.brown}{index}{fmt.fg.tab} "

    main = f"{title.split()[0]}"

    suffix = (
        f" {fmt.bold}{fmt.fg.blue}[Z]{fmt.fg.tab}{fmt.nobold}"
        if data["layout_name"] == "stack"
        else ""
    )

    return f"{prefix}{main}{suffix}"
