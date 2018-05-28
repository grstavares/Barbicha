/**
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

/**
 * Triggers when a user gets a new follower and sends a notification.
 *
 * Followers add a flag to `/followers/{followedUid}/{followerUid}`.
 * Users save their device notification tokens to `/users/{followedUid}/notificationTokens/{notificationToken}`.
 */
exports.updateStatus = functions.firestore
.document('/barbershops/{barbershopId}/appointments/{appointmentId}')
.onUpdate((change, context) => {

  const barbershopId = context.params.barbershopId;
  const appointmentId = context.params.appointmentId;
  const newData = change.after.data();
  const customerId = newData.customerUUID;
  const newStatus = newData.status;

  let tokensSnapshot;
  let tokens;

  // Get the list of device notification tokens.
  return admin.firestore().doc(`/persons/${customerId}`).get()
  .then(results => {

    const data = results.data();
    const tokens = data.messageToken;

    const payload = {
      notification: {
        title: 'Seu agendamento foi atualizado!',
        body: `O status do seu agendamento foi alterado para ${newStatus}`,
        icon: "icon"
      }
    };

    // tokensIds = Object.keys(tokens);
    return admin.messaging().sendToDevice(tokens, payload);

  }).then((response) => {

        // For each message check if there was an error.
        const tokensToRemove = [];
        response.results.forEach((result, index) => {
          const error = result.error;
          if (error) {
            console.error('Failure sending notification to', tokens[index], error);
            // Cleanup the tokens who are not registered anymore.
            if (error.code === 'messaging/invalid-registration-token' ||
                error.code === 'messaging/registration-token-not-registered') {
              tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
            }
          }
        });

        return Promise.all(tokensToRemove);

  });

});
