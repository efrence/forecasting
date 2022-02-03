require "application_system_test_case"

class WeatherTest < ApplicationSystemTestCase
  test "visiting the form" do
    visit '/forecasting/new'

    assert_selector "input"
  end

  test "Entering address" do
    visit '/forecasting/new'

    sleep 1

    find(".address-input").send_keys("90210")

    assert_selector "h1", wait: 5
  end
end
