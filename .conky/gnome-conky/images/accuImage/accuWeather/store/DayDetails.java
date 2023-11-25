package store;

public class DayDetails {

	String NL = "\n";
	String time = null;
	String icon = null;
	String cond = null;
	String hi = null;
	String temp = null;
	String realfeel = null;
	String wind = null;
	String windStats = null;
	String uvIndex = null;
	String stormProb = null;
	String humidity = null;
	String pressure = null;
	String cloudCover = null;
	String dewPoint = null;
	String amountOfPrecipitation = null;
	String visibility = null;

	public String getHumidity() {
		return humidity;
	}

	public void setHumidity(String humidity) {
		this.humidity = humidity;
	}

	public String getPressure() {
		return pressure;
	}

	public void setPressure(String pressure) {
		this.pressure = pressure;
	}

	public String getCloudCover() {
		return cloudCover;
	}

	public void setCloudCover(String cloudCover) {
		this.cloudCover = cloudCover;
	}

	public String getDewPoint() {
		return dewPoint;
	}

	public void setDewPoint(String dewPoint) {
		this.dewPoint = dewPoint;
	}

	public String getAmountOfPrecipitation() {
		return amountOfPrecipitation;
	}

	public void setAmountOfPrecipitation(String amountOfPrecipitation) {
		this.amountOfPrecipitation = amountOfPrecipitation;
	}

	public String getVisibility() {
		return visibility;
	}

	public void setVisibility(String visibility) {
		this.visibility = visibility;
	}

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	public String getCond() {
		return cond;
	}

	public void setCond(String cond) {
		this.cond = cond;
	}

	public String getHi() {
		return hi;
	}

	public void setHi(String hi) {
		this.hi = hi;
	}

	public String getTemp() {
		return temp;
	}

	public void setTemp(String temp) {
		this.temp = temp;
	}

	public String getRealfeel() {
		return realfeel;
	}

	public void setRealfeel(String realfeel) {
		this.realfeel = realfeel;
	}

	public String getWind() {
		return wind;
	}

	public void setWind(String wind) {
		this.wind = wind;
	}

	public String getWindStats() {
		return windStats;
	}

	public void setWindStats(String windStats) {
		this.windStats = windStats;
	}

	public String getUvIndex() {
		return uvIndex;
	}

	public void setUvIndex(String uvIndex) {
		this.uvIndex = uvIndex;
	}

	public String getStormProb() {
		return stormProb;
	}

	public void setStormProb(String stormProb) {
		this.stormProb = stormProb;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	@Override
	public String toString() {
		return time + " Icon:" + icon + NL + time + " Temp:" + temp + NL + time
				+ " Feel:" + realfeel + NL + time + " Cond:" + cond + NL + time
				+ " Wind:" + wind + NL + time + " UV:" + uvIndex + NL + time
				+ " Humi:" + humidity + NL + time + " Press:" + pressure + NL
				+ time + " Visi:" + visibility + NL + time + " Cloud:"
				+ cloudCover + NL + time + " Dew:" + dewPoint + NL + time
				+ " Presp:" + amountOfPrecipitation;
	}
}
