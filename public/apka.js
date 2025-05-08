const apiKey = 'c79e875d4dd8fa6f9ee766275ccb9d8e';

document.getElementById('weatherForm').addEventListener('submit', async (e) => {
  e.preventDefault();

  const city = document.getElementById('city').value;

  const url = `https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&lang=pl`;

  try {
    const response = await fetch(url);
    if (!response.ok) throw new Error('Nie udało się pobrać danych pogodowych.');

    const data = await response.json();
    const resultDiv = document.getElementById('result');
    resultDiv.innerHTML = `
      <h2>Pogoda dla: ${data.name}</h2>
      <p>Temperatura: ${data.main.temp} °F</p>
      <p>Opis: ${data.weather[0].description}</p>
      <p>Wilgotność: ${data.main.humidity}%</p>
      <p>Wiatr: ${data.wind.speed} m/s</p>
    `;
  } catch (error) {
    document.getElementById('result').innerText = error.message;
  }
});
