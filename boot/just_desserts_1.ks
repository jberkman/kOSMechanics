// Boot Script for Just Desserts 1
@lazyglobal off. {
    if not exists("1:/lib/dd.ks") copyPath("0:/lib/dd.ks", "1:/lib/dd.ks").
    runPath("1:/lib/dd.ks"). get("just_desserts_1/main.ks")().
}
