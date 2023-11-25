package processor;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import store.Constants;
import store.DayDetails;
import store.Details;

public class DayNodeProcessor implements Constants {

	private Node _inputNode = null;

	public DayNodeProcessor(Node inputNode) {
		this._inputNode = inputNode;
	}

	DayDetails _dayDetails = new DayDetails();
	DayDetails _nightDetails = new DayDetails();

	public Details processNode() {

		processIcon(getRequiredNode("day"), "day");
		processIcon(getRequiredNode("night"), "night");
		processTemp(getRequiredNode("day"), "day");
		processTemp(getRequiredNode("night"), "night");
		processFeel(getRequiredNode("day"), "day");
		processFeel(getRequiredNode("night"), "night");
		processCond(getRequiredNode("day"), "day");
		processCond(getRequiredNode("night"), "night");
		processWind(getRequiredNode("day"), "day");
		processWind(getRequiredNode("night"), "night");

		_dayDetails.setTime("Day");
		_nightDetails.setTime("Night");
		return new Details(_dayDetails, _nightDetails);
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
		} else {
			_nightDetails.setCond(tempNode.getTextContent().trim());
		}
	}

	private void processTemp(Node requiredNode, String time) {
		Node tempNode = ProcessorHelper.getRequiredNodeForAttribute(
				requiredNode, "span", "class", "temp");
		if (time.equals("day")) {
			_dayDetails.setTemp(tempNode.getTextContent().trim());
		} else {
			_nightDetails.setTemp(tempNode.getTextContent().trim());
		}
	}

	private void processFeel(Node requiredNode, String time) {
		Node tempNode = ProcessorHelper.getRequiredNodeForAttribute(
				requiredNode, "span", "class", "real");
		if (time.equals("day")) {
			_dayDetails.setRealfeel(tempNode.getTextContent()
					.replaceAll("RealFeel", "").trim());
		} else {
			_nightDetails.setRealfeel(tempNode.getTextContent()
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
		} else {
			_nightDetails.setIcon(icon + ".png");
		}
	}

	private void processWind(Node requiredNode, String time) {
		Node ulStats = ProcessorHelper.getRequiredNodeForAttribute(
				ProcessorHelper.getRequiredNodeForAttribute(ProcessorHelper
						.getRequiredNodeForAttribute(requiredNode, "div",
								"class", "rt"), "ul", "class", "stats"),
				"strong", "style", "");

		if (time.equals("day")) {
			_dayDetails.setWind(ulStats.getTextContent().trim());
		} else {
			_nightDetails.setWind(ulStats.getTextContent().trim());
		}

	}
}
