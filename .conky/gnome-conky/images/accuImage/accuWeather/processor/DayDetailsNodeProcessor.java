package processor;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import store.Constants;
import store.DayDetails;
import store.Details;

public class DayDetailsNodeProcessor implements Constants {

	private Node _inputNode = null;

	public DayDetailsNodeProcessor(Node inputNode) {
		this._inputNode = inputNode;
	}

	DayDetails _dayDetails = new DayDetails();

	public Details processNode() {

		processIcon(getRequiredNode("forecast"), "day");
		processTemp(getRequiredNode("forecast"), "day");
		processFeel(getRequiredNode("forecast"), "day");
		processCond(getRequiredNode("forecast"), "day");
		processMoreInfo(getRequiredNode("bg"), "day");
		_dayDetails.setTime("DayDetails");
		return new Details(_dayDetails, null);
	}

	/**
	 * This will be day or night. <div class="night"> or <div class="day">
	 * 
	 * @param time
	 */

	private Node getRequiredNode(String time) {
		NodeList childNodes = ((Document) _inputNode)
				.getElementsByTagName("div");
		Node requiredNode = null;

		for (int index = 0; index < childNodes.getLength(); index++) {
			if (childNodes.item(index).getAttributes().getNamedItem(classAttr)
					.getNodeValue().startsWith(time)) {
				requiredNode = childNodes.item(index);
				break;
			}
		}
		return requiredNode;
	}

	private void processCond(Node requiredNode, String time) {
		Node tempNode = ProcessorHelper.getRequiredNodeForAttribute(
				requiredNode, "span", "class", "cond");
		if (time.equals("day")) {
			_dayDetails.setCond(tempNode.getTextContent().trim());
		}
	}

	private void processTemp(Node requiredNode, String time) {
		Node tempNode = ProcessorHelper.getRequiredNodeForAttribute(
				requiredNode, "span", "class", "temp");
		if (time.equals("day")) {
			_dayDetails.setTemp(tempNode.getTextContent().trim());
		}
	}

	private void processFeel(Node requiredNode, String time) {
		Node tempNode = ProcessorHelper.getRequiredNodeForAttribute(
				requiredNode, "span", "class", "real");
		if (time.equals("day")) {
			_dayDetails.setRealfeel(tempNode.getTextContent()
					.replaceAll("RealFeel", "").trim());
		}
	}

	private void processIcon(Node requiredNode, String time) {
		Node iconNode = ProcessorHelper.getRequiredNodeForAttribute(
				requiredNode, "div", "class", "icon");
		String icon = iconNode.getAttributes().getNamedItem("class")
				.getNodeValue().replaceAll("icon i-", "")
				.replaceAll("i-alarm", "")
				+ "-l";

		if (iconNode.getAttributes().getNamedItem("class").getNodeValue()
				.replaceAll("icon i-", "").contains("alarm")) {
			icon = icon + "-alarm";
		}
		icon = icon.replaceAll(" ", "");
		// System.out.println(iconNode.getAttributes().getNamedItem("class")
		// .getNodeValue()
		// + " --> " + icon + ".png");
		if (time.equals("day")) {
			_dayDetails.setIcon(icon + ".png");
		}
	}

	private void processMoreInfo(Node requiredNode, String time) {
		Node ulStats = ProcessorHelper.getRequiredNodeForAttribute(
				ProcessorHelper.getRequiredNodeForAttribute(requiredNode,
						"div", "class", "more-info"), "ul", "class", "stats");

		NodeList liNodeList = ((Element) ulStats).getElementsByTagName("li");
		NodeList stNodeList = ((Element) ulStats)
				.getElementsByTagName("strong");
		int propertyCount = liNodeList.getLength();
		String property = null;
		String value = null;
		for (int index = 0; index < propertyCount; index++) {
			property = liNodeList.item(index).getTextContent();
			value = stNodeList.item(index).getTextContent();

			if (property.contains("Humidity")) {
				_dayDetails.setHumidity(value);
			} else if (property.contains("Pressure")) {
				_dayDetails.setPressure(value);
			} else if (property.contains("Cloud Cover")) {
				_dayDetails.setCloudCover(value);
			} else if (property.contains("UV Index")) {
				_dayDetails.setUvIndex(value);
			} else if (property.contains("Dew Point")) {
				_dayDetails.setDewPoint(value.replaceAll("C", " °C"));
			} else if (property.contains("Amount of Precipitation")) {
				_dayDetails.setAmountOfPrecipitation(value);
			} else if (property.contains("Visibility")) {
				_dayDetails.setVisibility(value);
			}

		}

	}
}
