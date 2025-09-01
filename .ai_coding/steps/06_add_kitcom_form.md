Read this documentation very carefully: https://help.kit.com/en/articles/2605079-trigger-a-modal-with-a-link-click

Once you know how it works, in the landing_page project make all the "Get early access" buttons open the kit.com form as a modal.

Here's the script mentioned in the "Embed the modal Form in your website" of the documentation:
<script async data-uid="1fe98e99bc" src="https://yef.kit.com/1fe98e99bc/index.js"></script>

And here's the modal trigger link:
<a data-formkit-toggle="1fe98e99bc" href="https://yef.kit.com/1fe98e99bc">Your link text</a>

And here's the button trigger link:
<a data-formkit-toggle="1fe98e99bc" href="https://yef.kit.com/1fe98e99bc" class="button">Button Text</a>
