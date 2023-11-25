package processor;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import store.Constants;
import store.MoonPhases;

public class MoonPhaseNodeProcessor implements Constants {

	private Node _inputNode = null;

	public MoonPhaseNodeProcessor(Node inputNode) {
		this._inputNode = inputNode;
	}

	MoonPhases _moonDetails = new MoonPhases();

	public MoonPhases processNode() {

		processMoonPhase(getRequiredNode());
		return _moonDetails;
	}

	/**
	 * This will be day or night. <div class="night"> or <div class="day">
	 * 
	 * @param time
	 */

	private Node getRequiredNode() {
		NodeList childNodes = ((Document) _inputNode)
				.getElementsByTagName("div");
		Node requiredNode = null;

		for (int index = 0; index < childNodes.getLength(); index++) {
			if (childNodes.item(index).getAttributes().getNamedItem(classAttr)
					.getNodeValue().startsWith("moon-phase")) {
				requiredNode = childNodes.item(index);
				break;
			}
		}
		return requiredNode;
	}

	private void processMoonPhase(Node requiredNode) {
		Node tempNode = ProcessorHelper.getRequiredNodeForAttribute(
				requiredNode, "img", "width", "110");
		String prefix = "";
		if (Integer.parseInt(tempNode.getAttributes().getNamedItem("src")
				.getNodeValue().split("/")[6].split("\\.")[0]) < 10) {
			prefix = "0";
		}
		_moonDetails.set_icon(prefix
				+ tempNode.getAttributes().getNamedItem("src").getNodeValue()
						.split("/")[6]);
		tempNode = ProcessorHelper.getRequiredNodeForAttribute(requiredNode,
				"h6", "src", "blah");
		_moonDetails.set_heading(tempNode.getTextContent().trim());
	}
}
