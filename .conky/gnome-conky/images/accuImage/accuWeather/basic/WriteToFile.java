/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package basic;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

/**
 * This Class is used for Monitoring the error messages and redirecting those to
 * the ErrorLog.txt File.
 * 
 * @author amit.kshirsagarindiatimes.com
 */
public class WriteToFile {
	/**
	 * This Method is static.
	 * <p>
	 * It takes error message as argument.
	 * <p>
	 * public static void toMonitorFile(String errorMassage)
	 */

	public static BufferedWriter fileWriter = null;

	// new BufferedWriter(new OutputStreamWriter(new
	// FileOutputStream("./FileOut/Datafile.txt"),"ISO8859_1"));
	public static void writeToFile(String writeMassage) {

		try {
			// FileWriter fileWriters = new FileWriter(toFile,true);
			System.out.println("\t" + writeMassage);
			fileWriter.write(writeMassage + "\n");
			// PrintWriter printWriter = new PrintWriter(fileWriter);
			// printWriter.println(writeMassage);
		} catch (Exception e) {
			System.out.println("Error In writing the Error output to the File"
					+ e.getMessage());
		}
	}

	public static void createWriter(String fileName) {
		try {
			File toFile = new File(fileName);

			/*
			 * ASCII :- &#xfc; -> ? Incorrect current format UTF-8 :- &#xfc; ->
			 * ü Incorrect format ISO8859_1 :- &#xfc; -> � Correct format
			 */
			fileWriter = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(toFile), "iso8859_9"));
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void printToFile(String writeMassage, String reportFile) {
		File errorFile = new File(reportFile);
		try {
			FileWriter fileWriter = new FileWriter(errorFile, false);
			PrintWriter printWriter = new PrintWriter(fileWriter);
			// System.out.print(writeMassage);
			printWriter.println(writeMassage);
			System.out.println(writeMassage);
			System.out
					.println("----------------------------------------------------\n");
			fileWriter.close();
		} catch (Exception e) {
			System.out.println("Error In writing the Error output to the File"
					+ e.getMessage());
		}
	}

	public static void closeFileWriter() {
		try {
			fileWriter.close();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}