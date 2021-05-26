import * as functions from 'firebase-functions';
// @ts-ignore incorrect typescript typings
import * as Mailchimp from 'mailchimp-api-v3';
const cors = require('cors');
const corsHandler = cors({ origin: true });

const _mailChimpId = functions.config().mailchimp.listid;
const _apiKey = functions.config().mailchimp.key;
let mailchimp: Mailchimp;
try {
  mailchimp = new Mailchimp(_apiKey);
} catch (err) {
  console.log(err);
}
exports.mailChimp = functions.https.onRequest((req, res) => {
  corsHandler(req, res, async () => {
    const email = req.body.email_address;
    const tags = req.body.tags;
    const language = req.body.language;
    try {
      console.log(`adding user ${email} with tags ${tags} (${req.body})`);
      const results = await mailchimp.post(`/lists/${_mailChimpId}/members`, {
        email_address: email,
        tags: tags,
        language: language,
        status: 'pending',
      });
      console.log(results);

      console.log(`Added user: ${email} status PENDING to Mailchimp audience: ${_mailChimpId}`);
      res.status(200).send('Success adding the user to the mailchimp list');
    } catch (error) {
      console.error('Error when adding user to Mailchimp audience', error);
      res.status(error.status).send(error.title);
    }
  });
});
