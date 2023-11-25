package processor;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class ConnectionProcessor {

	public static Document getMoonDayDocument(String url) {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db;
		Document doc = null;
		try {
			db = dbf.newDocumentBuilder();

			InputStream inStream = new URL(url).openStream();
			InputStreamReader inReader = new InputStreamReader(inStream);

			HttpURLConnection urlc = (HttpURLConnection) new URL(url)
					.openConnection();
			urlc.setAllowUserInteraction(false);
			urlc.setDoInput(true);
			urlc.setDoOutput(false);
			urlc.setUseCaches(true);
			urlc.setRequestMethod("GET");
			urlc.connect();
			// check you have received an status code 200 to indicate OK
			// get the encoding from the Content-Type header
			BufferedReader in = new BufferedReader(new InputStreamReader(
					urlc.getInputStream()));
			String line = null;
			StringBuilder stringBuilder = new StringBuilder();
			boolean startBuffering = false;
			int counter = 0;
			stringBuilder.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
					+ "<root>");
			while ((line = in.readLine()) != null) {

				boolean firstCount = false;
				if (line.contains("div class=\"moon-phase\"")) {
					startBuffering = true;
					firstCount = true;
					counter++;
				}
				while (startBuffering && counter > 0) {

					if (line.contains("<div") && line.contains("</div")) {

					} else if (line.contains("<div")) {
						if (firstCount) {
							firstCount = false;
						} else {
							counter++;
						}
					} else if (line.contains("</div")) {
						counter--;
					}
					if (line.contains("<h6")) {
						line = line.replaceAll("<h6", "<h6 src=\"blah\"");
					}

					line = line.replaceAll("&[a-z]+;", "");
					stringBuilder.append(line);
					line = in.readLine();

				}
			}

			stringBuilder.append("</root>");

			// System.out.println(stringBuilder.toString());
			dbf = DocumentBuilderFactory.newInstance();
			db = dbf.newDocumentBuilder();
			InputSource is = new InputSource();
			is.setCharacterStream(new StringReader(stringBuilder.toString()));

			doc = db.parse(is);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return doc;
	}

	public static Document getDayDocument(String url) {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db;
		Document doc = null;
		try {
			db = dbf.newDocumentBuilder();

			InputStream inStream = new URL(url).openStream();
			InputStreamReader inReader = new InputStreamReader(inStream);

			HttpURLConnection urlc = (HttpURLConnection) new URL(url)
					.openConnection();
			urlc.setAllowUserInteraction(false);
			urlc.setDoInput(true);
			urlc.setDoOutput(false);
			urlc.setUseCaches(true);
			urlc.setRequestMethod("GET");
			urlc.connect();
			// check you have received an status code 200 to indicate OK
			// get the encoding from the Content-Type header
			BufferedReader in = new BufferedReader(new InputStreamReader(
					urlc.getInputStream()));
			String line = null;
			StringBuilder stringBuilder = new StringBuilder();
			boolean startBuffering = false;
			int counter = 0;
			stringBuilder.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
					+ "<root>");
			while ((line = in.readLine()) != null) {

				boolean firstCount = false;
				if (line.contains("div id=\"detail-day-night\" class=\"detail-tab-panel\"")) {
					startBuffering = true;
					firstCount = true;
					counter++;
				}
				while (startBuffering && counter > 0) {

					if (line.contains("<div") && line.contains("</div")) {

					} else if (line.contains("<div")) {
						if (firstCount) {
							firstCount = false;
						} else {
							counter++;
						}
					} else if (line.contains("</div")) {
						counter--;
					}

					line = line.replaceAll("&[a-z]+;", "");
					// System.out.println(line);
					stringBuilder.append(line);
					line = in.readLine();

				}
			}

			stringBuilder.append("</root>");

			dbf = DocumentBuilderFactory.newInstance();
			db = dbf.newDocumentBuilder();
			InputSource is = new InputSource();
			is.setCharacterStream(new StringReader(stringBuilder.toString()));

			doc = db.parse(is);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return doc;
	}

	public static Document getDayDetailsDocument(String url) {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db;
		Document doc = null;
		try {
			db = dbf.newDocumentBuilder();

			InputStream inStream = new URL(url).openStream();
			InputStreamReader inReader = new InputStreamReader(inStream);

			HttpURLConnection urlc = (HttpURLConnection) new URL(url)
					.openConnection();
			urlc.setAllowUserInteraction(false);
			urlc.setDoInput(true);
			urlc.setDoOutput(false);
			urlc.setUseCaches(true);
			urlc.setRequestMethod("GET");
			urlc.connect();
			// check you have received an status code 200 to indicate OK
			// get the encoding from the Content-Type header
			BufferedReader in = new BufferedReader(new InputStreamReader(
					urlc.getInputStream()));
			String line = null;
			StringBuilder stringBuilder = new StringBuilder();
			boolean startBuffering = false;
			int counter = 0;
			stringBuilder.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
					+ "<root>");
			while ((line = in.readLine()) != null) {

				boolean firstCount = false;
				if (line.contains("div id=\"detail-now\" class=\"detail-tab-panel day\"")
						|| line.contains("div id=\"detail-now\" class=\"detail-tab-panel night\"")) {
					startBuffering = true;
					firstCount = true;
					counter++;
				}
				while (startBuffering && counter > 0) {

					if (line.contains("<div") && line.contains("</div")) {

					} else if (line.contains("<div")) {
						if (firstCount) {
							firstCount = false;
						} else {
							counter++;
						}
					} else if (line.contains("</div")) {
						counter--;
					}

					line = line.replaceAll("&[a-z]+;", "");
					stringBuilder.append(line);
					line = in.readLine();

				}
			}

			stringBuilder.append("</root>");

			// System.out.println(stringBuilder.toString());
			dbf = DocumentBuilderFactory.newInstance();
			db = dbf.newDocumentBuilder();
			InputSource is = new InputSource();
			is.setCharacterStream(new StringReader(stringBuilder.toString()));

			doc = db.parse(is);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return doc;
	}

}
