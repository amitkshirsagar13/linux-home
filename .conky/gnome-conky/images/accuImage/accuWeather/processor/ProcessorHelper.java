package processor;

import java.util.Date;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class ProcessorHelper {

	public static Node getRequiredNodeForAttribute(Node requiredNode,
			String element, String attribute, String value) {
		NodeList nodeList = ((Element) requiredNode)
				.getElementsByTagName(element);
		for (int index = 0; index < nodeList.getLength(); index++) {
			if (nodeList.item(index).getAttributes() != null
					&& nodeList.item(index).getAttributes()
							.getNamedItem(attribute) != null
					&& nodeList.item(index).getAttributes()
							.getNamedItem(attribute).getNodeValue()
							.startsWith(value)) {
				return nodeList.item(index);
			}
		}
		return null;
	}

	public static String getDay(int day) {
		Date date = new Date();
		int dayInt = date.getDay();
		String dayString = null;

		dayInt = dayInt + day;
		if (dayInt >= 7) {
			dayInt = dayInt - 7;
		}

		switch (dayInt) {
		case 0:
			dayString = "Sun";
			break;
		case 1:
			dayString = "Mon";
			break;
		case 2:
			dayString = "Tue";
			break;
		case 3:
			dayString = "Wed";
			break;
		case 4:
			dayString = "Thu";
			break;
		case 5:
			dayString = "Fri";
			break;
		case 6:
			dayString = "Sat";
			break;
		default:
		}
		return dayString;
	}
}
