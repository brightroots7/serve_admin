const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
admin.initializeApp();

// Validate environment variables
const gmailUser = process.env.GMAIL_MAIL;
const gmailPass = process.env.GMAIL_PASSWORD;

if (!gmailUser || !gmailPass) {
  console.error('Missing Gmail environment variables');
  process.exit(1); // Exit if variables missing
}

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: gmailUser,
    pass: gmailPass
  }
});

exports.sendAdminCredentials = functions.https.onCall(async (data, context) => {
  // Validate authentication
  if (!context.auth || !context.auth.token.admin) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Unauthorized. Only admins can send credentials.'
    );
  }

  // Validate request data
  if (!data.recipient || !data.adminEmail || !data.adminPassword) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing required fields: recipient, adminEmail, or adminPassword'
    );
  }

  const mailOptions = {
    from: `Temple Management <${gmailUser}>`,
    to: data.recipient,
    subject: 'Admin Credentials',
    text: `Temple Admin Credentials:\nEmail: ${data.adminEmail}\nPassword: ${data.adminPassword}`
  };

  try {
    await transporter.sendMail(mailOptions);
    return { status: 'success' };
  } catch (error) {
    console.error('Email send error:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to send email. Check function logs.'
    );
  }
});