import { Controller } from '@hotwired/stimulus';
import axios from 'axios';
import debounce from 'debounce';

export default class extends Controller {
  static targets = ['weather', 'address'];

  initialize() {
    this.debouncedFetchWeather = debounce(this.fetchWeather, 500);
    this.token = document.getElementById('csrf-token').value;
  }
  addressChanged(e) {
    e.preventDefault();
    this.debouncedFetchWeather(this.addressTarget.value);
  }
  displayWeather(address, zipcode, temp) {
    this.weatherTarget.textContent = `Temperature in ${address} with zipcode ${zipcode} is ${temp} C°`;
  }
  async fetchWeather(address) {
    const response = await axios.post('/forecasting/current_weather.json', {
        "forecasting": {"address": address },
      },
      {
        headers: {
          'X-CSRF-Token': this.token,
          'Content-Type': 'application/json'
        },
      }
    ).catch(
      (error) => {
        this.weatherTarget.textContent = '';
      }
    );
    if (response.status == 200 && response.data) {
      this.displayWeather(response.data.address, response.data.zipcode, response.data.temp_c);
    } else {
      this.weatherTarget.textContent = '';
    }
  }
}
