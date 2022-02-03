import { Controller } from '@hotwired/stimulus';
import axios from 'axios';
import debounce from 'debounce';

export default class extends Controller {
  static targets = ['forecasting', 'address'];

  initialize() {
    this.debouncedFetchWeather = debounce(this.fetchWeather, 500);
    this.token = document.getElementById('csrf-token').value;
  }
  addressChanged(e) {
    e.preventDefault();
    this.debouncedFetchWeather(this.addressTarget.value);
  }
  displayWeather(address, zipcode, temp) {
    this.forecastingTarget.textContent = `Temperature in ${address} with zipcode ${zipcode} is ${temp} C°`;
  }
  async fetchWeather(address) {
    try {
      axios.post('/forecasting/current_weather.json', {
          "forecasting": {"address": address },
        },
        {
          headers: {
            'X-CSRF-Token': this.token,
            'Content-Type': 'application/json'
          },
        }
      ).then((response) => {
        if (response && response.status == 200 && response.data) {
          this.displayWeather(response.data.address, response.data.zipcode, response.data.temp_c);
        } else {
          this.forecastingTarget.textContent = 'There was an error, please try again with a different address';
        }
      }).catch((error) => {
          if(error.response.status == 404){
            this.forecastingTarget.textContent = `No weather found for address: ${address}`;
          }
          if(error.response.status == 400){
            this.forecastingTarget.textContent = `Invalid address: ${address}`;
          }
        }
      );
    } catch (error) {
      console.log(error)
      this.forecastingTarget.textContent = 'There was an error, please try again later';
    }
  }
}
