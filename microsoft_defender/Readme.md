**This script enables Microsoft Defender settings.**

This script is intended for users who cannot have the Intune MDM configuration applied, as it enforces locked settings that restrict end-user control. By using this approach instead, users are allowed to temporarily disable Microsoft Defender if needed. In case the user forgets to re-enable Defender, this script will ensure it is automatically reactivated.

    Enables Microsoft Defender settings:
    - Real-time protection
    - Cloud-delivered protection
    - Automatic sample submission